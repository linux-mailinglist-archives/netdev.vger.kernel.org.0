Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB47865BCAF
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbjACJDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjACJDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:03:03 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAB863EA;
        Tue,  3 Jan 2023 01:03:01 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 1C6FB8521D;
        Tue,  3 Jan 2023 10:02:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1672736579;
        bh=W/cY0QMddmvfRRo7ab3mBCHH052GYIDTeJD+3SgNfWM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U/Cd6VIlx9Z7XB8qrSqof6k0LKyOmnMHQyOnWRXPOhZg4BrJ8jeBefOj4tZ5vkUYu
         n9DfO6w/6+r1H/UkVUYQpDEwI/GRyzDRwoCHR1Q0HajSaNnA0TcjA30A8nY2izf0rU
         GBDVn+FvZpdInffHr0nSTsgnEYnX3QuYDSSaW8XdZBzYPwQh7giyuqgTFrdBpiRlAt
         SICYRXDHX93+JKEd0TvV2Xzvq1aIzGV+dlY2kHB8nNfaG0TINnI55Aop340hVcW1Hq
         OuSE8M99f9tqWlCCmSdh08pq3uYdAl9lcDmT0est9vjkh33wYA6rOUolKFBKdHreal
         YWBJ54LH5RXXA==
Date:   Tue, 3 Jan 2023 10:02:51 +0100
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
Message-ID: <20230103100251.08a5db46@wsk>
In-Reply-To: <Y7M+mWMU+DJPYubp@lunn.ch>
References: <20230102150209.985419-1-lukma@denx.de>
        <Y7M+mWMU+DJPYubp@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9.BKqFsmyEdbBXSEI.kZdf6";
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

--Sig_/9.BKqFsmyEdbBXSEI.kZdf6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > @@ -3548,7 +3548,9 @@ static int mv88e6xxx_get_max_mtu(struct
> > dsa_switch *ds, int port) if (chip->info->ops->port_set_jumbo_size)
> >  		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN; else if (chip->info->ops->set_max_frame_size)
> > -		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN -
> > ETH_FCS_LEN;
> > +		return (max_t(int, chip->info->max_frame_size,
> > 1632)
> > +			- VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN);
> > +
> >  	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN; =20
>=20
> I would also prefer if all this if/else logic is removed, and the code
> simply returned chip->info->max_frame_size - VLAN_ETH_HLEN -
> EDSA_HLEN - ETH_FCS_LEN;
>=20

So then the mv88e6xxx_get_max_mtu shall look like:

WARN_ON_ONCE(!chip->info->max_frame_size)

if (chip->info->ops->port_set_jumbo_size)
...
else=20
    return chip->info->max_frame_size - VLAN_ETH_HLEN -
	EDSA_HLEN - ETH_FCS_LEN;


Or shall I put WARN_ON_ONCE to the mv88e6xxx_probe() function?


The above approach is contrary to one proposed by Alexander, who wanted
to improve the defensive approach in this driver (to avoid situation
where the max_frame_size callback is not defined and max_frame_size
member of *_info struct is not added by developer).

Which approach is the recommended one for this driver?

> > +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> > @@ -132,6 +132,7 @@ struct mv88e6xxx_info {
> >  	unsigned int num_gpio;
> >  	unsigned int max_vid;
> >  	unsigned int max_sid;
> > +	unsigned int max_frame_size; =20
>=20
> It might be worth adding a comment here what this value actually
> represents.

Ok. I will add proper comment.

> We don't want any mixups where the value already has the
> frame checksum removed for example.

Could you be more specific here about this use case?

The max_frame_size is the maximal size of the ethernet frame for which
the IC designer provided specified amount of RAM (it is a different
value for different SoCs in the Link Street family).

>=20
>       Andrew


Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/9.BKqFsmyEdbBXSEI.kZdf6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmOz7zsACgkQAR8vZIA0
zr2lowgAss/SWaBTUUuUWNlYNG1/D6Y7eyGx+iKzOkejIVZ+ssV5J5ojMm3qIE5p
PSF3+NXnUbb+H1fJGPGP3OhnWVYc6QSq4VOgSclTYxadKS11K9RpjiWtAbEVJOAs
6FrY2RRNGOf/iz5OgXgWhV6BqWczgyCbL6FBkHvaXZv6dym80ROlRpkcT4LbABVI
3ZZbz4BKBcxoKu+XfwVk/E7yYlefQ71i6n/tfTIK+x4iedQg2rLMlGaYPEkFhB3j
OtCZWcJkKvCFfPq6+tHPKZNGCgNdI2dUk9hyS1StYXUVUEYfo67kkBKwBnZV0AGx
3xG+vZFVNyFbiQKXKL8opPwv343KhQ==
=bXsa
-----END PGP SIGNATURE-----

--Sig_/9.BKqFsmyEdbBXSEI.kZdf6--
