Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AA66A4B59
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjB0TnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:43:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjB0TnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:43:24 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF5B7D94
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=a13gqsEzI3PRaBTQkWFrQwmDyoVa
        8dcFCLJhmS1nKaU=; b=RdWYRcfmdCwDcwSZmwpSdL6+K3jabmJzTQoCufcZb3Wk
        ZU21UzTIbQpgENvFnKBw1sbQqSPj5BAOnKZWCrlXnLp3/fAhaRA8fRwZ3FcpMls+
        1DteXl6d4pfbuH65eep/+uOiu+7Aehq7Yxc+YhMuiFGRv3OD2ce8TrDFwIHJE8E=
Received: (qmail 2227943 invoked from network); 27 Feb 2023 20:43:16 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 27 Feb 2023 20:43:16 +0100
X-UD-Smtp-Session: l3s3148p1@zMSIsLP1qKVehh92
Date:   Mon, 27 Feb 2023 20:43:12 +0100
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION PATCH RFC] net: phy: don't resume PHY via MDIO when
 iface is not up
Message-ID: <Y/0H0DOC4sl0kVo+@ninjato>
Mail-Followup-To: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
 <92332a2e-8e87-567d-7b4c-6ca779c866aa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9iKReve//AbKBJYz"
Content-Disposition: inline
In-Reply-To: <92332a2e-8e87-567d-7b4c-6ca779c866aa@gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9iKReve//AbKBJYz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Heiner,

> > This may be a problem in itself, but I then wondered why
> > mdio_bus_phy_resume() gets called anyhow because the RAVB driver sets
> > 'phydev->mac_managed_pm =3D true' so once the interface is up
> > mdio_bus_phy_resume() never gets called. But again, the interface was
> > not up yet, so mac_managed_pm was not set yet.
> >=20
> Setting phydev->mac_managed_pm in the open() callback is too late.
> It should be set as soon as the phydev is created. That's in
> ravb_mdio_init() after the call to of_mdiobus_register().
>=20
> It should be possible to get the phydev with:
> pn =3D of_parse_phandle(np, "phy-handle", 0);
> phy =3D of_phy_find_device(pn);

Awesome, thank you very much for the pointer. I applied setting
'mac_managed_pm' at probe time, and now I can resume successfully.
Sadly, this is only the first part of the problem. I still can't get the
interface up after resuming, but I still need to debug this further.
At least, the problem with mdiobus_resume getting called is fixed now.

Thank you for your help!

   Wolfram


--9iKReve//AbKBJYz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmP9B8wACgkQFA3kzBSg
KbbUBQ/7Bixpff3a8TawjAUPPSCFhhd+N+P//9fj7QxcqW7G0va/r10irlc5vW/+
mZbPWDRd5FcOsKngWIIVmtDjQQ9/ej0wpnv3E2zSyAQtk5xez/uGJa3UGmzVFweq
NVv1XQmETUGDnlHwXe8d4iJRwjICiJnqLhrkMHivC6aKfbXS1nLTLLZOetZzaMIu
z9bBJEAUk7bIk7vxEosvUC7Sc9z0fTPcNmP0IcKvB+qazqzEQd8+lsfh8ddUFXLQ
Ym0RiZAP8LM/VMPdXVXqJ0DsUytsE66sfMCXyNoqsH2qaqGa+bBdc8dSjDF7z6Es
/SgNmIUPo/1on9keXthMYOPlWgs3+0ndsm/veKP0Esr0PXAPE9dpwVEahxD6pBGj
g+Az0EPpctPZTQeO23G9AmyoLKSPR6HCRizwnb7j5JcJ/fbn6jRpLsOibqHGd2ny
uRtciJFXQa6C3pfRwti9aZh8hkCPQbBBNc/6MQkt1PivQvWT4fbfPWy4qeKo/T+H
E+IjykKmwscn00J46c/W04JPSUAfYuBVgNwurrgrGNaqPFI1FpJ41Y8xncgJz8G0
rBEEwBhoX2S/h0XjpOnKbecwR7sXtfv0l+PNutuoFZzYZW1yTbhmmKq2firB2bqR
xr23Gb0r7LYg68VuTH5BUfWBlQiPN6P32fGGL6x6kWldcFCzU9E=
=dyvs
-----END PGP SIGNATURE-----

--9iKReve//AbKBJYz--
