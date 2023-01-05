Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0BE65E917
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjAEKhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbjAEKh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:37:26 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DA444C4F;
        Thu,  5 Jan 2023 02:37:22 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A0BBA8531D;
        Thu,  5 Jan 2023 11:37:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672915040;
        bh=N6yv+vVaCjEH/Vdac9ex4yjrrpuU16UbKkONhTmDbDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PhSTmdky8PEq2J+EHeqsR8AGUd63hwnvcv5HioA+RxvNMt/D86NEciPzRXHy9biFg
         eujD8P/NPvLgj8oqweMJyRc4GrnKnQfSFwIKiyf/u1aLPqKQQdw+1yAOqS41mk1UU1
         qE52rNtXNGJlGbhPBt9A1P6vVlNy+s0NrorVCZ83NNN6/36kHyi3eP1hRo27ewrMb1
         D2F7xGigKvNFugRctEbJfYCPTerdlfmwraigjZN8b8LaR7lFBv4tJmVm3m/i0Cn49m
         I0iZ3yvtjQ8xn1+BwsOEdR6tD+lhYFHBFusxDS1SF2kkODr+78nE+CAN6qv3u3Y1BD
         qg8jHd5Hy5IbA==
Date:   Thu, 5 Jan 2023 11:37:12 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230105113712.2bf0d37b@wsk>
In-Reply-To: <20230103100251.08a5db46@wsk>
References: <20230102150209.985419-1-lukma@denx.de>
        <Y7M+mWMU+DJPYubp@lunn.ch>
        <20230103100251.08a5db46@wsk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6ww_7R43XAgS8UoX0pNf3AM";
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

--Sig_/6ww_7R43XAgS8UoX0pNf3AM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Alexander,

> Hi Andrew,
>=20
> > > @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > > dsa_switch *ds, int port) if
> > > (chip->info->ops->port_set_jumbo_size) return 10240 -
> > > VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; else if
> > > (chip->info->ops->set_max_frame_size)
> > > -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN;
> > > +		return (max_t(int, chip->info->max_frame_size,
> > > 1632)
> > > +			- VLAN_ETH_HLEN - EDSA_HLEN -
> > > ETH_FCS_LEN); +
> > >  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > > =20
> >=20
> > I would also prefer if all this if/else logic is removed, and the
> > code simply returned chip->info->max_frame_size - VLAN_ETH_HLEN -
> > EDSA_HLEN - ETH_FCS_LEN;
> >  =20
>=20
> So then the mv88e6xxx_get_max_mtu shall look like:
>=20
> WARN_ON_ONCE(!chip->info->max_frame_size)
>=20
> if (chip->info->ops->port_set_jumbo_size)
> ...
> else=20
>     return chip->info->max_frame_size - VLAN_ETH_HLEN -
> 	EDSA_HLEN - ETH_FCS_LEN;
>=20
>=20
> Or shall I put WARN_ON_ONCE to the mv88e6xxx_probe() function?
>=20
>=20
> The above approach is contrary to one proposed by Alexander, who
> wanted to improve the defensive approach in this driver (to avoid
> situation where the max_frame_size callback is not defined and
> max_frame_size member of *_info struct is not added by developer).
>=20
> Which approach is the recommended one for this driver?

Is there any decision regarding the preferred approach to rewrite this
code?

>=20
> > > +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> > > @@ -132,6 +132,7 @@ struct mv88e6xxx_info {
> > >  	unsigned int num_gpio;
> > >  	unsigned int max_vid;
> > >  	unsigned int max_sid;
> > > +	unsigned int max_frame_size;   =20
> >=20
> > It might be worth adding a comment here what this value actually
> > represents. =20
>=20
> Ok. I will add proper comment.
>=20
> > We don't want any mixups where the value already has the
> > frame checksum removed for example. =20
>=20
> Could you be more specific here about this use case?
>=20
> The max_frame_size is the maximal size of the ethernet frame for which
> the IC designer provided specified amount of RAM (it is a different
> value for different SoCs in the Link Street family).
>=20
> >=20
> >       Andrew =20
>=20
>=20
> Best regards,
>=20
> Lukasz Majewski
>=20
> --
>=20
> DENX Software Engineering GmbH,      Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email:
> lukma@denx.de




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/6ww_7R43XAgS8UoX0pNf3AM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmO2qFgACgkQAR8vZIA0
zr1r9wgAys1TrWSHvZUhjo0hrnAaM6SRfe7OiUa9FMrGJeQvyJ9CwoN0iU6NcdHd
PeNmg3VZ5mF9M32g+GbMjgMQLlHXiq7jc0qXpKUGxDhw6oO98z9knkuIor9IfNKm
sP2cjb/8hWMh+YjLR7h2Olj98QnkMGnbG6U7o4vfKzdcvpENxptzi0LxCELD/P2E
SUXg1L4US1ur7KSkNGT1M9FBXhGefTU38Knj2baKcVbfI6Q8z5t4GGUippqAyHhv
rn36AexE3cg+0Kp1byPzn+/atox4Pj1IbMutKVFxaYiUxt8fHhBt734MSyhZ4w9v
wyyfrK6mB08heO3nVnmYqOfV3A9vrQ==
=dqKk
-----END PGP SIGNATURE-----

--Sig_/6ww_7R43XAgS8UoX0pNf3AM--
