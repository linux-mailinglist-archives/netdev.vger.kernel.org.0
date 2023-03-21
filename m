Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F566C38C1
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCUR52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjCUR4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:56:52 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2816855507
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=X/XHGzweNcGnZj7J+RpSBa5nq+wT
        r0BLkAkcv70wsdM=; b=D+nVXfa0FkyurAG1/7M4V0Z5UKvwx0AkpfK84DU1Cz1j
        fRaH19mATwg5Ru7VOD01wnpi7ixQ4UzWzH4sGAQtN5NLTaDU9i3DBiNd25x/c7OY
        OXYQoEyAS0v3UmDsdvhS+ZChMb0cdBJJRjT3M9JBqXWRir7R9vLc1HhXUOfvv3s=
Received: (qmail 1364990 invoked from network); 21 Mar 2023 18:56:28 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2023 18:56:28 +0100
X-UD-Smtp-Session: l3s3148p1@bhIcw2z34N4ujnv6
Date:   Tue, 21 Mar 2023 18:56:25 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] smsc911x: avoid PHY being resumed when
 interface is not up
Message-ID: <ZBnvya7Q/brY+MEt@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20230320092041.1656-1-wsa+renesas@sang-engineering.com>
 <20230320092041.1656-3-wsa+renesas@sang-engineering.com>
 <7589589f340f1ecb49bc8ed852e1e2dddb384700.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dSX357otSPN9QRZc"
Content-Disposition: inline
In-Reply-To: <7589589f340f1ecb49bc8ed852e1e2dddb384700.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dSX357otSPN9QRZc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paolo,

> > In smsc911x_mii_probe(), I remove the sanity check for 'phydev' because
> > it was already done in smsc911x_mii_init(). Let me know if this is
> > acceptable or if a more defensive approach is favoured.
>=20
> Since this is a fix, I would keep the old check, too.

Yes, makes sense.

> > +	phydev =3D phy_find_first(pdata->mii_bus);
> > +	if (!phydev) {
> > +		netdev_err(dev, "no PHY found\n");
> > +		err =3D -ENOENT;
> > +		goto err_out_free_bus_2;
>=20
> Why don't you call mdiobus_unregister() in this error path?

Oversight. I will fix it.

Thank you for the review!


--dSX357otSPN9QRZc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmQZ78UACgkQFA3kzBSg
KbalWQ//QzAaCeqp5I/wIJj9fW3lDht8cVRIiUEco0sruEdxcE0uAKwVZ3FTtG69
lobHyWzyxzJA/EtbYFPB3CWoFTRs9yVb7Dl36fBtmXz6UrUZTiiZxD661Kj6I47t
CEcmNoMhVr+XBdNxE34vjKKe6lzFWzjOxJJEUmJ5heUbQPqpeHGH4ZDeBXb8s/8n
fGOKOgREQ3kyk9bVYFpwPO84tWVsY+07SbQ77/zgCqaGtkh/O8doQ2Rz+LQgZub1
Re8c/1ldwloHhQXj9p1RL/uIQCb3cR0zQD4TBDYy8M95Ip1y2PJg6islO2WGvNQJ
z1bp57CvFiNCxdT7ZfF6uc2ysr06leJGPhBlAiXxUNCiYhJ0pWvyDi+aoohtcMsP
rVYBikF4cASU8xxGLF6W3MUHy8W+zVubz+1Kz539L22Erb5Ca4rWpAN2n3WKYoZW
uFyG0gD/JD88UO31aeNwgXXrpIxyEZO0UAoWMBKyopWOP+exxQ5O/Q0mM/pYqlAa
aBf1t8ziO+3MJOoSgwOwU5UxAHUaRzc75GU4B//fg2SQipDzW4gwQU53bq2pnGQY
M2fXFbX1RdVkGcoSJud3Jf21El4lCUfakbnvclMKWyDzpC3Z/MDjJyJm5prFCTAw
04QYsJxmHhfbHH2Wn1nXOm+XZIW02S/K+P+o9vfD+etY+oix9KY=
=ptv0
-----END PGP SIGNATURE-----

--dSX357otSPN9QRZc--
