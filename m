Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B23E6696CB
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 13:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241202AbjAMMUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 07:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbjAMMUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 07:20:04 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65D47D9C8;
        Fri, 13 Jan 2023 04:13:40 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 69FBB85232;
        Fri, 13 Jan 2023 13:13:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1673612019;
        bh=J/U7KHP4KXz5e0asbqFdbCzP2TxQPDvlfoOPqB7U9+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yg3Rsrc72KpSIlP884baLc/K1DhWGtMkPhWNqSmHfyJLK3hZh5bNnZI3ycNCfTgER
         6jLVzjcdQ0hJvkt45btW1k6VteUZGA0ZOKRAE0AnkYzqDc5q56DP65NIcBjDoV7dXJ
         Ans3+3BaFPQ8vv+ehXPR331OuJUfRBNKLw65IR//kDhDwl32uP9sQ50hluwVQn99+B
         HebEUH0nMmzLxHKYfxoiKhLg3jGE0WHISj7Rvp0Ev87nInuLm1x0UXs9clPjSt7YQN
         UVehQ71cZCCFMZ51cp3djFu/lXzNNfwejxTcj7rMdgCPwqq55wb3t5i/KaiQOvAzNL
         e8+SEoLzpHc8g==
Date:   Fri, 13 Jan 2023 13:13:31 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230113131331.28ba7997@wsk>
In-Reply-To: <20230106145109.mrv2n3ppcz52jwa2@skbuf>
References: <20230106101651.1137755-1-lukma@denx.de>
        <20230106101651.1137755-1-lukma@denx.de>
        <20230106145109.mrv2n3ppcz52jwa2@skbuf>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WnDPSNFgBRDqwg_7+UoGrH1";
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

--Sig_/WnDPSNFgBRDqwg_7+UoGrH1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vladimir,

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
> > Signed-off-by: Lukasz Majewski <lukma@denx.de>
> >=20
> > ---
> > Changes for v2:
> > - Define max_frame_size with default value of 1632 bytes,
> > - Set proper value for the mv88e6250 switch SoC (linkstreet) family
> >=20
> > Changes for v3:
> > - Add default value for 1632B of the max frame size (to avoid
> > problems with not defined values)
> >=20
> > Changes for v4:
> > - Rework the mv88e6xxx_get_max_mtu() by using per device defined
> >   max_frame_size value
> >=20
> > - Add WARN_ON_ONCE() when max_frame_size is not defined
> >=20
> > - Add description for the new 'max_frame_size' member of
> > mv88e6xxx_info ---
> >  drivers/net/dsa/mv88e6xxx/chip.c | 41
> > ++++++++++++++++++++++++++++---- drivers/net/dsa/mv88e6xxx/chip.h |
> >  6 +++++ 2 files changed, 42 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c
> > b/drivers/net/dsa/mv88e6xxx/chip.c index 242b8b325504..fc6d98c4a029
> > 100644 --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -3545,11 +3545,10 @@ static int mv88e6xxx_get_max_mtu(struct
> > dsa_switch *ds, int port) {
> >  	struct mv88e6xxx_chip *chip =3D ds->priv;
> > =20
> > -	if (chip->info->ops->port_set_jumbo_size)
> > -		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN;
> > -	else if (chip->info->ops->set_max_frame_size)
> > -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN;
> > -	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
> > +	WARN_ON_ONCE(!chip->info->max_frame_size);
> > +
> > +	return chip->info->max_frame_size - VLAN_ETH_HLEN -
> > EDSA_HLEN
> > +		- ETH_FCS_LEN; =20
>=20
> VLAN_ETH_HLEN (18) + EDSA_HLEN (8) + ETH_FCS_LEN (4) =3D 30
>=20
> >  }
> > =20
> >  static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port,
> > int new_mtu) @@ -4955,6 +4954,7 @@ static const struct
> > mv88e6xxx_ops mv88e6250_ops =3D { .avb_ops =3D &mv88e6352_avb_ops,
> >  	.ptp_ops =3D &mv88e6250_ptp_ops,
> >  	.phylink_get_caps =3D mv88e6250_phylink_get_caps,
> > +	.set_max_frame_size =3D mv88e6185_g1_set_max_frame_size,
> >  };
> > =20
> >  static const struct mv88e6xxx_ops mv88e6290_ops =3D {
> > @@ -5543,6 +5543,7 @@ static const struct mv88e6xxx_info
> > mv88e6xxx_table[] =3D { .num_internal_phys =3D 5,
> >  		.max_vid =3D 4095,
> >  		.max_sid =3D 63,
> > +		.max_frame_size =3D 1522, =20
>=20
> 1522 - 30 =3D 1492.
>=20
> I don't believe that there are switches which don't support the
> standard MTU of 1500 ?!

I think that this commit [1], made the adjustment to fix yet another
issue.

It looks like the missing 8 bytes are added in the
mv88e6xxx_change_mtu() function.

>=20
> >  		.port_base_addr =3D 0x10,
> >  		.phy_base_addr =3D 0x0,
> >  		.global1_addr =3D 0x1b, =20
>=20
> Note that I see this behavior isn't new. But I've simulated it, and it
> will produce the following messages on probe:
>=20
> [    7.425752] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY
> [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) [
> 7.437516] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to
> 1500 on port 0 [    7.588585] mscc_felix 0000:00:00.5 swp1
> (uninitialized): PHY [0000:00:00.3:11] driver [Microsemi GE VSC8514
> SyncE] (irq=3DPOLL) [    7.600433] mscc_felix 0000:00:00.5: nonfatal
> error -34 setting MTU to 1500 on port 1 [    7.752613] mscc_felix
> 0000:00:00.5 swp2 (uninitialized): PHY [0000:00:00.3:12] driver
> [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) [    7.764457] mscc_felix
> 0000:00:00.5: nonfatal error -34 setting MTU to 1500 on port 2 [
> 7.900771] mscc_felix 0000:00:00.5 swp3 (uninitialized): PHY
> [0000:00:00.3:13] driver [Microsemi GE VSC8514 SyncE] (irq=3DPOLL) [
> 7.912501] mscc_felix 0000:00:00.5: nonfatal error -34 setting MTU to
> 1500 on port 3
>=20
> I wonder, shouldn't we first fix that, and apply this patch set
> afterwards?

IMHO, it is up to Andrew to decide how to proceed, as the
aforementioned patch [1] is an attempt to fix yet another issue [2].



Links:

[1] -
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Db9c587fed61cf88bd45822c3159644445f6d5aa6

[2] -
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D1baf0fac10fbe3084975d7cb0a4378eb18871482

Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/WnDPSNFgBRDqwg_7+UoGrH1
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPBSusACgkQAR8vZIA0
zr39sQgAmvQlm34Ino/bdyQl4HVlGaXQYKK8lr5Ogu3YrpegMVLAm7vwdxE5FA+p
svWH0FMsCSzfLaWpVXI5tYIjJSGGXccynOfsOKmfRag3Kb8tn5zcV0KHH9Jz1WyN
rxj7Tp5lf921fEGexW1dSYUQWoDI/nVwm88hmabbea8wovDwa9Szj+DhVLaI/Asd
xKKvlV7IXICXFrUgLVD8MKhOcCaEAc7gHd4w2PKy0nMmRWCyO5XQT+91Nm5OK+QU
oJT2tu7xE1vfrwDI2atM5mXi/CuLskyQL1xc4lpB71XJ7TUhsUfnJKXG5K8f5LkI
gYoKmY25x4cE4UQ+IwQFiV+z2yX9xQ==
=TyKL
-----END PGP SIGNATURE-----

--Sig_/WnDPSNFgBRDqwg_7+UoGrH1--
