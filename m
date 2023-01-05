Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F6965F310
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbjAERoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 12:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbjAERoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 12:44:37 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 672693DBDE;
        Thu,  5 Jan 2023 09:44:35 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 75AC485172;
        Thu,  5 Jan 2023 18:44:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672940673;
        bh=vgxfht1qCanXLi0U+RL9riFtYEW17cKX1yDlrdAShes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jpVJ1FBan8bihsKzVWSalku+BZtFfdWLsqVkVcgv5URCRyU5uNKz8GFzNjJ2pgk6f
         TC/Gs3VXq+/NUuTic1uF3NilE1gtGjVo7UQBBQJMyha40cLxaCEWk1f0nusUrPRZQn
         3IlaeMVDoVxODgT7AVasQEGVEyRT+AdI4tYXEj9e99O9fe3fLdWkL1RxjInS/TQK7S
         EE26LPfL5YvCHxcLyuIFSIIW3E94NnOZMxN8QDvwR5gOZKiVryoqzKGVXeSZAtKH3q
         HOCHnBUtNj39so+o17yR1x6TOwYLRKqdeAh7h0By0ToxxO9N5AIdy4NvXVUaXVKx/H
         uEu/Uf14vHQdQ==
Date:   Thu, 5 Jan 2023 18:44:19 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230105184419.7b409a2d@wsk>
In-Reply-To: <CAKgT0UfjtKL0_OxKpEt4CzA4MztXckkVxMZkQ85B11bYomfOOw@mail.gmail.com>
References: <20230102150209.985419-1-lukma@denx.de>
        <Y7M+mWMU+DJPYubp@lunn.ch>
        <20230103100251.08a5db46@wsk>
        <20230105113712.2bf0d37b@wsk>
        <CAKgT0UfjtKL0_OxKpEt4CzA4MztXckkVxMZkQ85B11bYomfOOw@mail.gmail.com>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ZHXtXWOGpywgiwRYNY4ds54";
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

--Sig_/ZHXtXWOGpywgiwRYNY4ds54
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexander

> On Thu, Jan 5, 2023 at 2:37 AM Lukasz Majewski <lukma@denx.de> wrote:
> >
> > Hi Andrew, Alexander,
> > =20
> > > Hi Andrew,
> > > =20
> > > > > @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > > > > dsa_switch *ds, int port) if
> > > > > (chip->info->ops->port_set_jumbo_size) return 10240 -
> > > > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; else if
> > > > > (chip->info->ops->set_max_frame_size)
> > > > > -         return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > > ETH_FCS_LEN;
> > > > > +         return (max_t(int, chip->info->max_frame_size,
> > > > > 1632)
> > > > > +                 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > > > ETH_FCS_LEN); +
> > > > >   return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > > > =20
> > > >
> > > > I would also prefer if all this if/else logic is removed, and
> > > > the code simply returned chip->info->max_frame_size -
> > > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > > =20
> > >
> > > So then the mv88e6xxx_get_max_mtu shall look like:
> > >
> > > WARN_ON_ONCE(!chip->info->max_frame_size)
> > >
> > > if (chip->info->ops->port_set_jumbo_size)
> > > ...
> > > else
> > >     return chip->info->max_frame_size - VLAN_ETH_HLEN -
> > >       EDSA_HLEN - ETH_FCS_LEN;
> > >
> > >
> > > Or shall I put WARN_ON_ONCE to the mv88e6xxx_probe() function?
> > >
> > >
> > > The above approach is contrary to one proposed by Alexander, who
> > > wanted to improve the defensive approach in this driver (to avoid
> > > situation where the max_frame_size callback is not defined and
> > > max_frame_size member of *_info struct is not added by developer).
> > >
> > > Which approach is the recommended one for this driver? =20
> >
> > Is there any decision regarding the preferred approach to rewrite
> > this code? =20
>=20
> I would defer to what Andrew proposed since he has more experience
> with the DSA code than I do.
>=20

Ok, then I will prepare v4 according to Andrew suggestions.

Thanks for the update :-)

> Thanks,
>=20
> - Alex




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/ZHXtXWOGpywgiwRYNY4ds54
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmO3DHMACgkQAR8vZIA0
zr1iaQgAxgSS4qcjJ3bj72zzCG0v08fmLzxYZzg7ge+ooLbzqjzOVHONWWvPZmtu
zSE21mRcUOQqh7E0NRoVJ0A9sXKVtFVMUk/EIlZNa9cXFTiKw14FYrAlv4NXujDO
LVjs8lY40rUbY5wOploY9KIZk5eXLFhwWo6WNTuor5ogutg3/jpNlj0LHjmyQe9v
B2mPPJuSmcGFOfS4yC+GXBsK7oAToa3ULLxWjiwfvL5xRfO3shh4VSaYupu47nwJ
j1DTeCWuaTDYYo6CLXlukV35KAvsDE/lA6NtTJOg43FaPBUUB2nW6YrUfk5x+mS0
tBt7+FySdBAUJ6IE1YY9YH0uMWuX/w==
=okRi
-----END PGP SIGNATURE-----

--Sig_/ZHXtXWOGpywgiwRYNY4ds54--
