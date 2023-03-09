Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF26F6B277B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjCIOog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbjCIOoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:44:21 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648735CEEA;
        Thu,  9 Mar 2023 06:44:00 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 8EFF485DCF;
        Thu,  9 Mar 2023 15:43:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678373038;
        bh=uNtxW9PuxNtEv8F6P5VbTBX0XdsaKqaHd1sSxeSAaeI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PnG3ERWl0DqjDLxsRsMaXInt1x+2rI4yBcJI4qOnGLs0IqbtgTKvwd4glK8jpXLdW
         hWayVmaY5GkfOemI9glBY5WltAQEmjjHadyfpkfg3f6I7EYZb0KQfNNQJjhrguMHH4
         5dcVqzdPhasr7+Fhsq5/kL0WYmtoInnl9y7EVbBkx1X7XgKDVJi6DMX7TsbkY6tAdW
         3nL3KiMTEsrBcfu03WAcrsMJyHHHDHCbxt7zqXDF1sgwNkqKlz1174dhYkWHsps2wG
         1UAy73iRoifxhjwnV4y2FSbi0GoR9Jea/ojU1XTB0jOGKnXVVeNtlnaLXw7MMVCRSY
         Fj7QsGrhW3PAA==
Date:   Thu, 9 Mar 2023 15:43:50 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <20230309154350.0bdc54c8@wsk>
In-Reply-To: <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-7-lukma@denx.de>
        <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vs=WVZeAS0owu99XcNnn3P=";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vs=WVZeAS0owu99XcNnn3P=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Thu, Mar 09, 2023 at 01:54:20PM +0100, Lukasz Majewski wrote:
> > Running of the mv88e6xxx_validate_frame_size() function provided
> > following results:
> >=20
> > [    1.585565] BUG: Marvell 88E6020 has differing max_frame_size:
> > 1632 !=3D 2048 [    1.592540] BUG: Marvell 88E6071 has differing
> > max_frame_size: 1632 !=3D 2048 ^------ Correct -> mv88e6250 family
> > max frame size =3D 2048B
> >=20
> > [    1.599507] BUG: Marvell 88E6085 has differing max_frame_size:
> > 1632 !=3D 1522 [    1.606476] BUG: Marvell 88E6165 has differing
> > max_frame_size: 1522 !=3D 1632 [    1.613445] BUG: Marvell 88E6190X
> > has differing max_frame_size: 10240 !=3D 1522 [    1.620590] BUG:
> > Marvell 88E6191X has differing max_frame_size: 10240 !=3D 1522 [
> > 1.627730] BUG: Marvell 88E6193X has differing max_frame_size: 10240
> > !=3D 1522 ^------ Needs to be fixed!!!
> >=20
> > [    1.634871] BUG: Marvell 88E6220 has differing max_frame_size:
> > 1632 !=3D 2048 [    1.641842] BUG: Marvell 88E6250 has differing
> > max_frame_size: 1632 !=3D 2048 ^------ Correct -> mv88e6250 family
> > max frame size =3D 2048B =20
>=20
> If I understand this correctly, in patch 4, you add a call to the 6250
> family to call mv88e6185_g1_set_max_frame_size(), which sets a bit
> called MV88E6185_G1_CTL1_MAX_FRAME_1632 if the frame size is larger
> than 1518.

Yes, correct.

>=20
> However, you're saying that 6250 has a frame size of 2048. That's
> fine, but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632 rather misleading
> as a definition. While the bit may increase the frame size, I think
> if we're going to do this, then this definition ought to be renamed.
>=20

I thought about rename, but then I've double checked; register offset
and exact bit definition is the same as for 6185, so to avoid
unnecessary code duplication - I've reused the existing function.

Maybe comment would be just enough?

> That said, I would like Andrew and Vladimir's thoughts on this too.
>=20

Ok.

> Finally, I would expect, if this series was done the way I suggested,
> that patch 1 should set the max frame size according to how the
> existing code works, which means patch 2, being the validation patch,
> should be completely silent if patch 1 is correct - and that's the
> entire point of validating. It's to make sure that patch 1 is
> correct.

Ok.

>=20
> If it isn't correct, then patch 1 is wrong and should be updated.
>=20

Please correct my understanding - I do see two approaches here:


A. In patch 1 I do set the max_frame_size values (deduced). Then I add
validation function (patch 2). This function shows "BUG:...." only when
we do have a mismatch. In patch 3 I do correct the max_frame_size
values (according to validation function) and remove the validation
function. This is how it is done in v5 and is going to be done in v6.


B. Having showed the v5 in public, the validation function is known.
Then I do prepare v6 with only patch 1 having correct values (from the
outset) and provide in the commit message the code for validation
function. Then patch 2 and 3 (validation function and the corrected
values of max_frame_size) can be omitted in v6.

For me it would be better to choose approach B.

> Essentially, this patch should only exist if the values we are using
> today are actually incorrect.
>=20
> To put this another way, the conversion from our existing way of
> determining the max mtu to using the .max_frame_size method should be
> an entire no-op from the driver operation point of view. Then any
> errors in those values should be fixed and explained in a separate
> commit. Then the new support added.
>=20
> At least that's how I see it. Andrew and Vladimir may disagree.
>=20




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/vs=WVZeAS0owu99XcNnn3P=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQJ8KcACgkQAR8vZIA0
zr2jWQgA4WKkrUiFVA73xvGMMbixVLICXasATf2ikEGYpEvO0gVpgzmnsqXcqjVR
SEcESCbtpI2XqpsL/HL7zgXCLIQKZ8xIXxLcPF5z4QX9iB95VfCmL6mg4xsuDo4O
gm9dx5X8wnoLCBlOFsno4qTLWoS5ltiGwjwqIAK57lFyecn8QA7R7hU0FEDapmMu
Fy6WcXziRc1mkNBPq3RgjnA1Jv/DmaJakzS8uQ1TJAtC6/6WR474oCdOqsRlL1gd
xDLOrbWQctI2LgwgHbdA7B4VvzsZnTYsHgcbEShDvVDophEuwCz5IdKdtytYBdli
FPGt1l6uqZjSuqGWBRp99erjzjU//A==
=RA20
-----END PGP SIGNATURE-----

--Sig_/vs=WVZeAS0owu99XcNnn3P=--
