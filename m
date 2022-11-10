Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9096247D7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbiKJRCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKJRCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:02:38 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1814615D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:02:35 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id DBC5584D70;
        Thu, 10 Nov 2022 18:02:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668099754;
        bh=l/GKta6T8yj+VvC/k788D+loxvdAcPZpD6bNA/8T3f4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EMXGiZFg2Asz8UMaOG4apMznMA41N84gZlKdRtooZ2sPRdVFjRNif0+Hq9TMX2K5P
         CTNlM+GOJ1K+VirYErxKJuBR19PuBnNygoIgySAtKhbRx2N2P/U3nSl1zTHJ376iev
         6jGaZtirdJSgS5wsS5a8An3t1XLC8SqgNnNGHu2bA2HGpqtJCDeX3Ax6Ps/FHqxSvf
         Ls4FbgUQYDIKNG2gsUJ/UtR88Ls/rHyC9nIXk2v4rf0RQ7nogBZ2a0EqBc43DEW0Pn
         lcgr3pzHKmNgIbqBL8xyTG/NVM0prw7mXOV1ACvIh3q9dDF7p8VVpfuNVf+B3V8mx4
         uNwg28B4STafw==
Date:   Thu, 10 Nov 2022 18:02:33 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 2/9] net: dsa: mv88e6xxx: account for PHY base address
 offset in dual chip mode
Message-ID: <20221110180233.3ce3dd06@wsk>
In-Reply-To: <Y2pZD/3AQV1gjbFV@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-3-lukma@denx.de>
        <Y2pZD/3AQV1gjbFV@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pMg+vSD7XOI42ax6tYRID/Q";
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

--Sig_/pMg+vSD7XOI42ax6tYRID/Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Tue, Nov 08, 2022 at 09:23:23AM +0100, Lukasz Majewski wrote:
> > From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> >=20
> > In dual chip mode (6250 family), not only global and port registers
> > are shifted by sw_addr, but also the PHY addresses. Account for
> > this in the IRQ mapping. =20
>=20
> > +++ b/drivers/net/dsa/mv88e6xxx/smi.c
> > @@ -186,5 +186,9 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip
> > *chip, if (chip->smi_ops->init)
> >  		return chip->smi_ops->init(chip);
> > =20
> > +	chip->phy_base_addr =3D chip->info->phy_base_addr;
> > +	if (chip->info->dual_chip)
> > +		chip->phy_base_addr +=3D sw_addr;
> > +
> >  	return 0; =20
>=20
>=20
> Again, reviewing first to last, i assume the will be a patch soon
> implementing get_phy_address(), and it will have the same logic. Why
> not call it here, a default implementation which returns
> info->phy_base_addr, and a version for 6250 which returns sw_addr.
>=20

I will squash Matthias patches and prepare new set of them with proper
operation's ordering.

> 	Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/pMg+vSD7XOI42ax6tYRID/Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNtLqkACgkQAR8vZIA0
zr2oLQf9GT6NGRWNXx1TbP5O2iUJWhgELE7fgdYokx7/E47yQSUGFJgdltm13C78
B4QlqIqGBMuzq3DFTLM6dyZuc2XoDe1DwYUI8LpO2ZTS47z5rCYPmn0lXOiiCIs4
lQTb1j7MCIBDIiYbuvKtqkj0ITcbTJqFNs3TLgwpndxopODAwN+gbFaUIoc7aExW
nuFqmriNVAmKCC1D2cwJ9O3RnSU7omQYpP49EqTIJujmla5fRvYPbwSrJ1yUBVWp
f4wnvX3Ck1b6lcENlOrqiE9IS7G405cljm4MNScJ/Cu48Y5SDkIuUtZpg2ExyY6g
jZfZTaaP6E0As+Cc1lQn50Or8bjrig==
=UFX/
-----END PGP SIGNATURE-----

--Sig_/pMg+vSD7XOI42ax6tYRID/Q--
