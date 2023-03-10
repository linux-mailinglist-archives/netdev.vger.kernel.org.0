Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C346B401C
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjCJNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbjCJNTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:19:36 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D0A14EA7;
        Fri, 10 Mar 2023 05:19:31 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A61BD85F02;
        Fri, 10 Mar 2023 14:19:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678454370;
        bh=T1qPTroUrw41HD5Kfj4vg6ghP9BlWSvXjEv3ypvyj5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHfYaLYyxqDHW8ytxTby+1NIJqQSwyu0oR1Esw5TZcBoz5N/6ty8j0oEzgXDnVr2S
         sQ78rBpdcU6x59RStvVoIsUDUzGxgW9xxpjyJjd3LfLXv6IRGWnIC+gHrkjrswl+y/
         eR8CtJILtoIOyaLWpskCbBynYkBPvLypxTcZXBvhHMZoio7+02jeV+gnCMrYXFc3qD
         QLHpeNnVKt3zi7BeQMVzKVcUsqYsbAck7JhTb8nv05DIQG4smZVbClhqhjsmG3J5Mm
         Bvo/clTF+7wBHmiQ58wLkZ8w4K4/Ag+b+YpvkLizP6dMJ5PbTafVJ4/+afrKo3PMVF
         rSvhc5e+XAv/g==
Date:   Fri, 10 Mar 2023 14:19:28 +0100
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
Message-ID: <20230310141928.00b08422@wsk>
In-Reply-To: <ZAsdN3j8IrL0Pn0J@shell.armlinux.org.uk>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-7-lukma@denx.de>
        <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
        <20230309154350.0bdc54c8@wsk>
        <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
        <20230310125346.13f93f78@wsk>
        <ZAsdN3j8IrL0Pn0J@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/aAiJ219S1SCy7CqP8Ir=2Hx";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/aAiJ219S1SCy7CqP8Ir=2Hx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Fri, Mar 10, 2023 at 12:53:46PM +0100, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> > > > > If I understand this correctly, in patch 4, you add a call to
> > > > > the 6250 family to call mv88e6185_g1_set_max_frame_size(),
> > > > > which sets a bit called MV88E6185_G1_CTL1_MAX_FRAME_1632 if
> > > > > the frame size is larger than 1518.   =20
> > > >=20
> > > > Yes, correct.
> > > >    =20
> > > > >=20
> > > > > However, you're saying that 6250 has a frame size of 2048.
> > > > > That's fine, but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632
> > > > > rather misleading as a definition. While the bit may increase
> > > > > the frame size, I think if we're going to do this, then this
> > > > > definition ought to be renamed.  =20
> > > >=20
> > > > I thought about rename, but then I've double checked; register
> > > > offset and exact bit definition is the same as for 6185, so to
> > > > avoid unnecessary code duplication - I've reused the existing
> > > > function.
> > > >=20
> > > > Maybe comment would be just enough?   =20
> > >=20
> > > The driver takes care with its namespace in order to add per
> > > switch family defines. So you can add
> > > MV88E6250_G1_CTL1_MAX_FRAME_2048. It does not matter if it is the
> > > same bit. You can also add a mv88e6250_g1_set_max_frame_size()
> > > and it also does not matter if it is in effect the same as
> > > mv88e6185_g1_set_max_frame_size().
> > >=20
> > > We should always make the driver understandably first, compact and
> > > without redundancy second. We are then less likely to get into
> > > situations like this again where it is not clear what MTU a device
> > > actually supports because the code is cryptic. =20
> >=20
> > Ok, I will add new function.
> >=20
> > Thanks for hints. =20
>=20
> It may be worth doing:
>=20
> static int mv88e6xxx_g1_modify(struct mv88e6xxx_chip *chip, int reg,
> 			       u16 mask, u16 val)
> {
> 	int addr =3D chip->info->global1_addr;
> 	int err;
> 	u16 v;
>=20
> 	err =3D mv88e6xxx_read(chip, addr, reg, &v);
> 	if (err < 0)
> 		return err;
>=20
> 	v =3D (v & ~mask) | val;
>=20
> 	return mv88e6xxx_write(chip, addr, reg, v);
> }
>=20
> Then, mv88e6185_g1_set_max_frame_size() becomes:
>=20
> int mv88e6185_g1_set_max_frame_size(struct mv88e6xxx_chip *chip, int
> mtu) {
> 	u16 val =3D 0;
>=20
> 	if (mtu + ETH_HLEN + ETH_FCS_LEN > 1518)
> 		val =3D MV88E6185_G1_CTL1_MAX_FRAME_1632;
>=20
> 	return mv88e6xxx_g1_modify(chip, MV88E6XXX_G1_CTL1,
> 				   MV88E6185_G1_CTL1_MAX_FRAME_1632,
> val); }
>=20

Yes, correct.

> The 6250 variant becomes similar.
>=20
> We can also think about converting all those other read-modify-writes
> to use mv88e6xxx_g1_modify().
>=20
> The strange thing is... we already have mv88e6xxx_g1_ctl2_mask() which
> is an implementation of mv88e6xxx_g1_modify() specifically for
> MV88E6XXX_G1_CTL2 register, although it uses (val & mask) rather than
> just val. That wouldn't be necessary if the bitfield macros (e.g.
> FIELD_PREP() were used rather than explicit __bf_shf().
>=20

I do have the impression that major refactoring of the mv6xxx driver
would be welcome...


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/aAiJ219S1SCy7CqP8Ir=2Hx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQLLmAACgkQAR8vZIA0
zr15EQgA0yZDpPb/UbKFQTl0gCCg94biTlYLgVqpjHqax+hhsgCx69Zla2jAV16e
cGSNsOctFiJTSc7YI3KQQN6o7M1qV5foywwN9ob8UgKzQDDFdZvUWa0JhSQLp7rw
UhEEA3wTY7RYiEGKjAXBHbxjMsAok+RlOGUakUzuiZjpfLtHnSDz91OyEIKFCOtc
Qb/nDUGeq55777JmHmxrHpU8YgkV5wA0yRQbkjxN+/cFR9+Td4Dh17jizYOE0160
neChoGoW+4TsMTLg3lP4n/6IU046IZ79aNZzDGKTO0FRNZeNXI3HTSDXUC6WnxSK
WDG3qV5hX//iklNHHHhFsnHRlJp0EQ==
=zMRB
-----END PGP SIGNATURE-----

--Sig_/aAiJ219S1SCy7CqP8Ir=2Hx--
