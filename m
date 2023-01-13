Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF3766947C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 11:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjAMKlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 05:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbjAMKkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 05:40:09 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE50477D04;
        Fri, 13 Jan 2023 02:39:18 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9A7A68514E;
        Fri, 13 Jan 2023 11:39:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673606356;
        bh=KA96RYD1CKneCE6gPLEvOa5cIlBMyFJqP0xgdi3fmD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U4LkekVgfIm7B7PeGyUswQhaexHQDre9hj3Zrv33hKTCzUre0l/zql2Wr5AhEUXxF
         944dbhxxmkWMcezJIR0JFCX1cMXG2vKRsLVC5ikFTSXBozaQkH0wnLyJtuAjiAsngM
         FleVQLvha8bIRhwRdafV6EjfWgYje9Ac1ru0jM3QhqKv2nj0Vfb6mWtGmbxOEXKLyv
         /i0fgLQ7DKRvcToc6hVApXHCT/LZKu0z4Sun/Qm2GhSrxHoW+9UgR/Bfal/VccXPUx
         wH9U6/zLbmLOzFYoP4UYIzDzgcCwXdYfiCyfPZIrygPbmmd76RMde5emEGBuuJaxxn
         nqtP/yD1O+ZPw==
Date:   Fri, 13 Jan 2023 11:39:08 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113113908.5e92b3a5@wsk>
In-Reply-To: <Y7gdNlrKkfi2JvQk@lunn.ch>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y7gdNlrKkfi2JvQk@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yp1o9E.Cc4ROXEhjWoeWoyK";
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

--Sig_/yp1o9E.Cc4ROXEhjWoeWoyK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Vladimir,

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
> > (e.g. .set_max_frame_size, .port_set_jumbo_size).
> >=20
> > Signed-off-by: Lukasz Majewski <lukma@denx.de> =20
>=20
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>=20
> FYI: It is normal to include a patch 0/X for a patchset, which
> explains the big picture of the patchset. Please try to remember this
> for your next patchset.
>=20
>     Andrew
>=20
>=20

Are there any more comments, or is this patch set eligible for pulling
into net-next tree?


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/yp1o9E.Cc4ROXEhjWoeWoyK
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPBNMwACgkQAR8vZIA0
zr1cSwf/ec82AhBqwAtzjvWFakY3UEKFtL0GB9AaXOL0OVaZ6+nrn8xlYOY3MEfI
zMTODeB2irm7qKgTYUp2piS/hMc9E/UjNlqzZigPKqJH0+p5TbwATWBDIx4/U+vW
/WydbKBlo7RwkJoLDctsJWP0W6jFfKKZDg4xK2Ya/hcJzaGLt3VZwoETBu0nxL/c
Pm8jPo7qmDm9H7BB94yOKshQ6xR/yU1gCOmiD75IdOIvSKxO6Z7zGh3V5sHJX1nL
4j3CRqK9+WlHM652NdLUXgSr365DgYd+ciy1hizHWly4Q9faZPmo28Fc96CnHZEX
7t82LsJfp/0/bQwWrfPLEiGDu6aX8Q==
=fVB1
-----END PGP SIGNATURE-----

--Sig_/yp1o9E.Cc4ROXEhjWoeWoyK--
