Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B65F1CC8
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 16:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJAObk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 10:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJAObk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 10:31:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D029B275C0
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 07:31:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1oedWh-0008C6-0X; Sat, 01 Oct 2022 16:31:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oedWf-0040gV-St; Sat, 01 Oct 2022 16:31:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1oedWd-004tVR-E3; Sat, 01 Oct 2022 16:31:31 +0200
Date:   Sat, 1 Oct 2022 16:31:31 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Douglas Miller <dougmill@linux.ibm.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>, kernel@pengutronix.de
Subject: Strangeness in ehea network driver's shutdown
Message-ID: <20221001143131.6ondbff4r7ygokf2@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rkjaq67m5pqy2dhl"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rkjaq67m5pqy2dhl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

while doing some cleanup I stumbled over a problem in the ehea network
driver.

In the driver's probe function (ehea_probe_adapter() via
ehea_register_memory_hooks()) a reboot notifier is registered. When this
notifier is triggered (ehea_reboot_notifier()) it unregisters the
driver. I'm unsure what is the order of the actions triggered by that.
Maybe the driver is unregistered twice if there are two bound devices?
Or the reboot notifier is called under a lock and unregistering the
driver (and so the devices) tries to unregister the notifier that is
currently locked and so results in a deadlock? Maybe Greg or Rafael can
tell about the details here?

Whatever the effect is, it's strange. It makes me wonder why it's
necessary to free all the resources of the driver on reboot?! I don't
know anything about the specifics of the affected machines, but I guess
doing just the necessary stuff on reboot would be easier to understand,
quicker to execute and doesn't have such strange side effects.

With my lack of knowledge about the machine, the best I can do is report
my findings. So don't expect a patch or testing from my side.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--rkjaq67m5pqy2dhl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmM4Tz8ACgkQwfwUeK3K
7AnIcQf+LTX5DG1gse6ihncTx1hMDIGxXlHIZN92lK63idGxxMVDq6UqV3XYWvxa
Hh/RNbtEkRWx1gS8KZlykrH0qjpw6+FLi9Bt349BVQzxNnxLvzMY1nnnO5mc/hy0
ghWjw7jxVXqCqIdLIlnGmHmDrcgPJY7x+/orZhVt0IBa/ttEZO1Jejv6e+0mr8EZ
Nyv+HtBTdH1XOaxw5cGdW2ajZOQLkBLmWUt6ZRPWVajUu9sA74wPOCM6vHwmTTXt
hC2QgMX0awTvQuvXZgBVr3PrJa7kydmiY5gqEF1+KZJPUfcjepWm+H2U0ox0XDLo
mzY8b0mwe/CXWf8WH/CGdGXM9b2Y6A==
=U6Oc
-----END PGP SIGNATURE-----

--rkjaq67m5pqy2dhl--
