Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4476B3E6B
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 12:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCJLyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 06:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCJLx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 06:53:58 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E222C2237;
        Fri, 10 Mar 2023 03:53:56 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1D5B185ACE;
        Fri, 10 Mar 2023 12:53:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1678449234;
        bh=U4tJ4knp+QbdBfJB/Gn1BrKZ/iCY4ZlOxNtMsP5bVHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z+ob/J5MC45jO4WZcvTpcTWFYgmprYE6yAEpeVZ9cwydoYVQ1MIrwzaMR4DQxRcwd
         ccABxY/KCjwrhPwbkzS0F65fxKaCid+iI8CO7fUSFHhMTNc0g7633U7WQapXriATyW
         Rpu/xqggk6VpfkSGFoTDupkC9xPiDxBIfwCfCDEjbgIa+8m+3n33Nb5NhybGBDqPF2
         v7nFWF1xwaWTv6934ioO4eHyDFPTDN7vuQhyVXwURbfoSuwBaiHsZXQus5m4uV0Gl4
         1mAM4wET1d+N9AxJ9Kd7BLITweOZ0w+N07Y4emM1m3CR0dYyU0B3Mhm1FxS3POJmQk
         QXhYRseA82QvQ==
Date:   Fri, 10 Mar 2023 12:53:46 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] dsa: marvell: Correct value of max_frame_size
 variable after validation
Message-ID: <20230310125346.13f93f78@wsk>
In-Reply-To: <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
References: <20230309125421.3900962-1-lukma@denx.de>
        <20230309125421.3900962-7-lukma@denx.de>
        <ZAnnk5MZc0w4VkDE@shell.armlinux.org.uk>
        <20230309154350.0bdc54c8@wsk>
        <0959097a-35cb-48c1-8e88-5e6c1269852d@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Dvf7PR1/0ITtVjq0t1uCiIa";
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

--Sig_/Dvf7PR1/0ITtVjq0t1uCiIa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > If I understand this correctly, in patch 4, you add a call to the
> > > 6250 family to call mv88e6185_g1_set_max_frame_size(), which sets
> > > a bit called MV88E6185_G1_CTL1_MAX_FRAME_1632 if the frame size
> > > is larger than 1518. =20
> >=20
> > Yes, correct.
> >  =20
> > >=20
> > > However, you're saying that 6250 has a frame size of 2048. That's
> > > fine, but it makes MV88E6185_G1_CTL1_MAX_FRAME_1632 rather
> > > misleading as a definition. While the bit may increase the frame
> > > size, I think if we're going to do this, then this definition
> > > ought to be renamed.=20
> >=20
> > I thought about rename, but then I've double checked; register
> > offset and exact bit definition is the same as for 6185, so to avoid
> > unnecessary code duplication - I've reused the existing function.
> >=20
> > Maybe comment would be just enough? =20
>=20
> The driver takes care with its namespace in order to add per switch
> family defines. So you can add MV88E6250_G1_CTL1_MAX_FRAME_2048. It
> does not matter if it is the same bit. You can also add a
> mv88e6250_g1_set_max_frame_size() and it also does not matter if it is
> in effect the same as mv88e6185_g1_set_max_frame_size().
>=20
> We should always make the driver understandably first, compact and
> without redundancy second. We are then less likely to get into
> situations like this again where it is not clear what MTU a device
> actually supports because the code is cryptic.

Ok, I will add new function.

Thanks for hints.

>=20
> 	 Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/Dvf7PR1/0ITtVjq0t1uCiIa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQLGksACgkQAR8vZIA0
zr3w7ggA1Hor5Ep2XfYJkQ3gTvfuczGbFeLyddNyhJ5qcRue6rXH7kTT7TLmm89M
X80VLozQDLpcLo8TodfPfaK8aT4ynvO8KyLHmh19AOnmU7FWuMoZUJiGvRZ8xXif
mvvUQpuC8l7ce9UtiQ08QbRzHw3f11oUrN3DYQbnqCtPW1WV+mpBfMeoigS2buQg
Jhqgh7kGTUaUop1EqdQbD5sGc3YUMofYmJB1keZ2ZQwmRNLnxhp041FHA+8azA2M
5y2zFdzWlearfYr7/Q7rq7OC6QvI/gMLJ4+AkFxpu76z+7AjwtgEnh/vJpKGny3N
0fQnTO1kN5+FIAwtXoAr/OWOMYb1/A==
=eF9h
-----END PGP SIGNATURE-----

--Sig_/Dvf7PR1/0ITtVjq0t1uCiIa--
