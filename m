Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F164017B9
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240441AbhIFITQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240260AbhIFITP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:19:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B01C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 01:18:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mN9pP-0005q5-Ih; Mon, 06 Sep 2021 10:18:07 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-4919-df7f-870a-a6c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:4919:df7f:870a:a6c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 857816775A7;
        Mon,  6 Sep 2021 08:18:06 +0000 (UTC)
Date:   Mon, 6 Sep 2021 10:18:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] can: netlink: prevent incoherent can
 configuration in case of early return
Message-ID: <20210906081805.dyd74xfu74gcnslg@pengutronix.de>
References: <20210903071704.455855-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rrycmjrnbv6ttokf"
Content-Disposition: inline
In-Reply-To: <20210903071704.455855-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rrycmjrnbv6ttokf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.09.2021 16:17:04, Vincent Mailhol wrote:
> struct can_priv has a set of flags (can_priv::ctrlmode) which are
> correlated with the other fields of the structure. In
> can_changelink(), those flags are set first and copied to can_priv. If
> the function has to return early, for example due to an out of range
> value provided by the user, then the global configuration might become
> incoherent.
>=20
> Example: the user provides an out of range dbitrate (e.g. 20
> Mbps). The command fails (-EINVAL), however the FD flag was already
> set resulting in a configuration where FD is on but the databittiming
> parameters are empty.
>=20
> * Illustration of above example *
>=20
> | $ ip link set can0 type can bitrate 500000 dbitrate 20000000 fd on
> | RTNETLINK answers: Invalid argument
> | $ ip --details link show can0
> | 1: can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group d=
efault qlen 10
> |     link/can  promiscuity 0 minmtu 0 maxmtu 0
> |     can <FD> state STOPPED restart-ms 0
>            ^^ FD flag is set without any of the databittiming parameters.=
=2E.
> | 	  bitrate 500000 sample-point 0.875
> | 	  tq 12 prop-seg 69 phase-seg1 70 phase-seg2 20 sjw 1
> | 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp=
-inc 1
> | 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp=
-inc 1
> | 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_ma=
x_segs 65535
>=20
> To prevent this from happening, we do a local copy of can_priv, work
> on it, an copy it at the very end of the function (i.e. only if all
> previous checks succeeded).

I don't like the optimization of using a static priv. If it's too big to
be allocated on the stack, allocate it on the heap, i.e. using
kmemdup()/kfree().

> Once this done, there is no more need to have a temporary variable for
> a specific parameter. As such, the bittiming and data bittiming (bt
> and dbt) are directly written to the temporary priv variable.
>=20
> Finally, function can_calc_tdco() was retrieving can_priv from the
> net_device and directly modifying it. We changed the prototype so that
> it instead writes its changes into our temporary priv variable.

Is it possible to split this into a separate patch, so that the part
without the tdco can be backported more easily to older kernels not
having tdco? The patch fixing the tdco would be the 2nd patch...

> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> ---
> Resending because I got no answers on:
> https://lore.kernel.org/linux-can/20210823024750.702542-1-mailhol.vincent=
@wanadoo.fr/T/#u
> (I guess everyone bas busy with the upcoming merge window)

Busy yes, but not with the merge window :)

> I am not sure whether or not this needs a "Fixes" tag. Just in case,
> there it is:
>=20
> Fixes: 9859ccd2c8be ("can: introduce the data bitrate configuration for C=
AN FD")

=2E..if it's possible to split this patch into 2 parts, add individual
fixes tags to them.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rrycmjrnbv6ttokf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmE1zrsACgkQqclaivrt
76msFwf/SL0XkEAhaxhdBuuALp3rJfdjijUtMv0n4CyhfcUNLaWIWPDnCLr5E7tG
yfzQksVxVSloEp8IsezBdsMQi6sKmHu+ocO3BbIAEihPJDhfCySnrrmRhM51M0Ka
N/f3u5yl5GjlASXfGQ1NIKlRGjDsb1yyR5TSYFq4wYUnb/N21lNvi28ST2nUFM8R
KvI1zajrCpmMJJXBcYHuQiYOUG1duUF/MGcCFD4lZS9OciFNEC3w7TKXQ0T5nr2o
MJrr4tYmYDInR4TigKO4kZvk/BgpeFdhdC/Q2cVhxpaJYsSdyMGmHXmNlrdFhJvG
HhM0RlZLBMSbqksJkw4PL5fr3/578Q==
=iwQ/
-----END PGP SIGNATURE-----

--rrycmjrnbv6ttokf--
