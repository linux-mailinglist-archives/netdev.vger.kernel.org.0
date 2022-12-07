Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E4464555E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiLGIXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiLGIXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:23:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F2A248EB
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:23:06 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1p2pho-0001kH-DL; Wed, 07 Dec 2022 09:23:04 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p2phl-002scw-4p; Wed, 07 Dec 2022 09:23:01 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1p2phl-003Eno-7q; Wed, 07 Dec 2022 09:23:01 +0100
Date:   Wed, 7 Dec 2022 09:23:01 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>, netdev@vger.kernel.org,
        Douglas Miller <dougmill@linux.ibm.com>, gpiccoli@igalia.com,
        kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Strangeness in ehea network driver's shutdown
Message-ID: <20221207082301.vfkh2zoty54rhhsv@pengutronix.de>
References: <20221001143131.6ondbff4r7ygokf2@pengutronix.de>
 <20221003093606.75a78f22@kernel.org>
 <CALJn8nN-5DZZkwrJurtT2NOUXGdEQa-aQt+MHvsii2oC_w5+FA@mail.gmail.com>
 <Y491kVZdw2lLB3yU@quatroqueijos.cascardo.eti.br>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5exu7kd75hueigfs"
Content-Disposition: inline
In-Reply-To: <Y491kVZdw2lLB3yU@quatroqueijos.cascardo.eti.br>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5exu7kd75hueigfs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 02:02:09PM -0300, Thadeu Lima de Souza Cascardo wro=
te:
> On Tue, Dec 06, 2022 at 01:49:01PM -0300, Guilherme G. Piccoli wrote:
> > On Mon, Oct 3, 2022 at 1:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Sat, 1 Oct 2022 16:31:31 +0200 Uwe Kleine-K=F6nig wrote:
> > > > Hello,
> > > >
> > > > while doing some cleanup I stumbled over a problem in the ehea netw=
ork
> > > > driver.
> > > >
> > > > In the driver's probe function (ehea_probe_adapter() via
> > > > ehea_register_memory_hooks()) a reboot notifier is registered. When=
 this
> > > > notifier is triggered (ehea_reboot_notifier()) it unregisters the
> > > > driver. I'm unsure what is the order of the actions triggered by th=
at.
> > > > Maybe the driver is unregistered twice if there are two bound devic=
es?
>=20
> I see how you would think it might be called for every bound device. That=
's
> because ehea_register_memory_hooks is called by ehea_probe_adapter. Howev=
er,
> there is this test here that leads it the reboot_notifier to be registere=
d only
> once:
>=20
> [...]
> static int ehea_register_memory_hooks(void)
> {
> 	int ret =3D 0;
>=20
> 	if (atomic_inc_return(&ehea_memory_hooks_registered) > 1)
> 	^^^^^^^^^^^^^^^^^^^^^^
> 		return 0;
> [...]

Ah, I see.

> > > > Or the reboot notifier is called under a lock and unregistering the
> > > > driver (and so the devices) tries to unregister the notifier that is
> > > > currently locked and so results in a deadlock? Maybe Greg or Rafael=
 can
> > > > tell about the details here?
> > > >
> > > > Whatever the effect is, it's strange. It makes me wonder why it's
> > > > necessary to free all the resources of the driver on reboot?! I don=
't
>=20
> As for why:
>=20
> commit 2a6f4e4983918b18fe5d3fb364afe33db7139870
> Author: Jan-Bernd Themann <ossthema@de.ibm.com>
> Date:   Fri Oct 26 14:37:28 2007 +0200
>=20
>     ehea: add kexec support
>    =20
>     eHEA resources that are allocated via H_CALLs have a unique identifie=
r each.
>     These identifiers are necessary to free the resources. A reboot notif=
ier
>     is used to free all eHEA resources before the indentifiers get lost, =
i.e
>     before kexec starts a new kernel.
>    =20
>     Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

I don't understand that, but that's fine for me.

As you're happy with the state as is, I consider the Case closed. Thanks
for looking into my bug report.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--5exu7kd75hueigfs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmOQTWIACgkQwfwUeK3K
7Am1Jwf+PQlJ5ujwgwNBXbeZeKDIz7xVWI/ly2U2uEfLFFa56sKeCfA6aqIY+6lQ
sbKJmMe6bUZ2TZKrb5SvX9yh8duggwEmD+iMNvSKiRG8YZ7x212Xq/lYTGmQYh+3
hszj9XQwdHyBYogumKNfZBg4nIAjVBVp1HrGsx1tiYT9gvQQfZkdoTyiAePhTZSc
82NuBJ0aTjJcF+mEP2HQYKB2OVkuJXnx9pE02s6RZ5P0vrqSmftq9Al1nc3ev3PF
aHJl1tSoyGhjhhpHHQRT0x0DyaywggCzwLPVaObGDV8zb7VqqzVjH0pC8G6lWfkk
C6vi8FbUYfMoS+6cRHC4fp6D3ivKqg==
=3mgO
-----END PGP SIGNATURE-----

--5exu7kd75hueigfs--
