Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07CC401D04
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 16:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243437AbhIFOcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 10:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243274AbhIFOcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 10:32:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B048C061575
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 07:31:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mNFeE-000511-Sr; Mon, 06 Sep 2021 16:30:58 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-4919-df7f-870a-a6c2.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:4919:df7f:870a:a6c2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 199E16782F0;
        Mon,  6 Sep 2021 14:30:58 +0000 (UTC)
Date:   Mon, 6 Sep 2021 16:30:57 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH v2] can: netlink: prevent incoherent can
 configuration in case of early return
Message-ID: <20210906143057.zrpor5fkh67uqwi2@pengutronix.de>
References: <20210903071704.455855-1-mailhol.vincent@wanadoo.fr>
 <20210906081805.dyd74xfu74gcnslg@pengutronix.de>
 <CAMZ6Rq+tNxU5ePDivMdwkbZK_hyao9hSyd0DrXnF503Qk1duqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sal5ak2ol57i6ub6"
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+tNxU5ePDivMdwkbZK_hyao9hSyd0DrXnF503Qk1duqw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sal5ak2ol57i6ub6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.09.2021 23:17:40, Vincent MAILHOL wrote:
> > > To prevent this from happening, we do a local copy of can_priv, work
> > > on it, an copy it at the very end of the function (i.e. only if all
> > > previous checks succeeded).
> >
> > I don't like the optimization of using a static priv. If it's too big to
> > be allocated on the stack, allocate it on the heap, i.e. using
> > kmemdup()/kfree().
>=20
> The static declaration is only an issue of coding style, correct?

I don't know (but I haven't checked) if the coding style doc says
anything about that.

> Or is there an actual risk of doing so?

As you pointed out, this relies on the serialization of the changelink
callback by the networking stack. There's no sane way in C to track this
requirement in the networking stack, so I don't want to have any
roadblocks and/or potential bugs in the CAN code. Marking a variable as
static places it in the BSS section, right? This mean, the memory is
always "used", even if not setting the bitrate.

> This is for my understanding, I will remove the static
> declaration regardless of your answer.

tnx

> On my x86_64 machine, sizeof(priv) is 448 and if I declare priv on the st=
ack:
> | $ objdump -d drivers/net/can/dev/netlink.o | ./scripts/checkstack.pl
> | 0x00000000000002100 can_changelink []:            1200
>=20
> So I will allocate it on the heap.

Sounds reasonable.

> N.B. In above figures CONFIG_CAN_LEDS is *off* because that driver
> was tagged as broken in:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D30f3b42147ba6f29bc95c1bba34468740762d91b

ok - BTW: I think we can remove LEDs support now, it's marked as broken
for more than 3 years.

> > > Once this done, there is no more need to have a temporary variable for
> > > a specific parameter. As such, the bittiming and data bittiming (bt
> > > and dbt) are directly written to the temporary priv variable.
> > >
> > > Finally, function can_calc_tdco() was retrieving can_priv from the
> > > net_device and directly modifying it. We changed the prototype so that
> > > it instead writes its changes into our temporary priv variable.
> >
> > Is it possible to split this into a separate patch, so that the part
> > without the tdco can be backported more easily to older kernels not
> > having tdco? The patch fixing the tdco would be the 2nd patch...
>=20
> ACK. I will send a v3 with that split.

Thanks for helping taking care of the LTS kernels!

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--sal5ak2ol57i6ub6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmE2Jh4ACgkQqclaivrt
76kXPAf+LawgzZhe3NINCbn5Mu+zFOBLsgk+OtKnx+ZRL51tTZn1pwhqnSABSyvG
rhs6sdK3JEPTDgdj9T8odyZKbBf7SYAKshiYwH/DTZPVaxEBgyDzJWoYCRdcXaz0
Vslz4o3LZzmdEEL6KVIoji6B7zqNQGmmjn2FKQzJAZ40kgrK/FylBru0tr7XPwbj
DvHeScws/Nh6zTcUJabQJeYT9sL+sA4pXUMle2wlbC94sAVOvz8uiSVYuQyZbRlM
VV+20cJvSiAV/SXK6yUmK6H+zGilHuHhe/QyTsz9WjqPHgb5IKHQBNC8hwsDPD3K
M6329A8OqA35p7XU7eV+SVb+ZQZOfA==
=Ut4l
-----END PGP SIGNATURE-----

--sal5ak2ol57i6ub6--
