Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA3766BAEC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjAPJwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjAPJwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:52:09 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF94818B0F;
        Mon, 16 Jan 2023 01:51:56 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 78AB884F3E;
        Mon, 16 Jan 2023 10:51:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673862715;
        bh=AriQnM0aPmdyQ63JyxY6+PYRD6b7/e5rfRLzvkdM2R4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bJxAQW0ZM1gD7LrZPN42GA+aAVqUVuI2OaeCOqjJDwJ1Crf/M6vuC6KsPD1s/oGwL
         4HjSp/ckHchnTZUiOBWLh1N6UbktVYV5FU3w82QputJaJSeez96/3B/4GEQyzz7Njn
         NjqZEfmnm8Z7GhacQFyvRZDZ8eP7BbXpDkt9sFBSEcIH/Qllq9FSwpqZJ7P6tY/16H
         9QXCpUfgsbqtSq7ilLEfSWpKAmqKQA1sP2EtMK1VJon2qKHn7tS+qWXUxlBpotMF6X
         dbC0RXlUtmVI80vwHv9nYCMaMhjLRY4rwRD2LkFVgKWTUKxoR9ZgTlYYf3hSP5AanD
         ukFI67Z6b0/cA==
Date:   Mon, 16 Jan 2023 10:51:48 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230116105148.230ef4ae@wsk>
In-Reply-To: <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yxWGpSSJACP3k2nu2/8Ph_X";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/yxWGpSSJACP3k2nu2/8Ph_X
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski wrote:
> > Different Marvell DSA switches support different size of max frame
> > bytes to be sent. This value corresponds to the memory allocated
> > in switch to store single frame.
> >=20
> > For example mv88e6185 supports max 1632 bytes, which is now
> > in-driver standard value. On the other hand - mv88e6250 supports
> > 2048 bytes. To be more interresting - devices supporting jumbo
> > frames - use yet another value (10240 bytes)
> >=20
> > As this value is internal and may be different for each switch IC,
> > new entry in struct mv88e6xxx_info has been added to store it.
> >=20
> > This commit doesn't change the code functionality - it just provides
> > the max frame size value explicitly - up till now it has been
> > assigned depending on the callback provided by the IC driver
> > (e.g. .set_max_frame_size, .port_set_jumbo_size). =20
>=20
> I don't think this patch is correct.
>=20
> One of the things that mv88e6xxx_setup_port() does when initialising
> each port is:
>=20
>         if (chip->info->ops->port_set_jumbo_size) {
>                 err =3D chip->info->ops->port_set_jumbo_size(chip,
> port, 10218); if (err)
>                         return err;
>         }
>=20
> There is one implementation of this, which is
> mv88e6165_port_set_jumbo_size() and that has the effect of setting
> port register 8 to the largest size. So any chip that supports the
> port_set_jumbo_size() method will be programmed on initialisation to
> support this larger size.
>=20
> However, you seem to be listing e.g. the 88e6190 (if I'm interpreting
> the horrid mv88e6xxx_table changes correctly)

Those changes were requested by the community. Previous versions of
this patch were just changing things to allow correct operation of the
switch ICs on which I do work (i.e. 88e6020 and 88e6071).

And yes, for 88e6190 the max_frame_size =3D 10240, but (by mistake) the
same value was not updated for 88e6190X.

The question is - how shall I proceed?=20

After the discussion about this code - it looks like approach from v3
[1] seems to be the most non-intrusive for other ICs.

> as having a maximum
> frame size of 1522, but it implements this method, supports 10240, and
> thus is programmed to support frames of that size rather than 1522.
>=20

Links:

[1] - https://lore.kernel.org/netdev/Y7M+mWMU+DJPYubp@lunn.ch/T/


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/yxWGpSSJACP3k2nu2/8Ph_X
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPFHjQACgkQAR8vZIA0
zr1KBQgAqlq+nldC7Wy1tHVtLEpJID5+bW/abhyGBhyW9F9NAbU9AqstcJMEhuEr
IPllCMvauw96YEveGfklueBgoilKvdzhAHlef1UEDSXdX5lZviWyLhiRkZYl3Qx5
OBEvpMQULe1UvZ8mhjgO/IQ09FYGpNGx5ac/IqHawIN363pyRiry7y52DUN7rbjA
ubLs8TIa8/DtWJA03cMO4VfMNowMEI5vAKyNli9ojKFKSTddG7H0lvdG2TNn/ycZ
tNZSDHZi0s3DfZB+wbUWfgUqmdHPIygsqAGHHPKp04i7P5IVNnRbVUGFuOLoWpfe
RB7DQRIa40DfPKZ6v9f/UA+Kaw7oLw==
=Yiso
-----END PGP SIGNATURE-----

--Sig_/yxWGpSSJACP3k2nu2/8Ph_X--
