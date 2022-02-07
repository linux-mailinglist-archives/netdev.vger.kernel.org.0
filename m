Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AC24AB7B0
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240583AbiBGJTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238698AbiBGJR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:17:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1669C043187
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 01:17:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nH090-0006MV-T6; Mon, 07 Feb 2022 10:17:10 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5A8732D37D;
        Mon,  7 Feb 2022 08:11:27 +0000 (UTC)
Date:   Mon, 7 Feb 2022 09:11:23 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Message-ID: <20220207081123.sdmczptqffwr64al@pengutronix.de>
References: <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
 <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
 <24e6da96-a3e5-7b4e-102b-b5676770b80e@hartkopp.net>
 <20220128080704.ns5fzbyn72wfoqmx@pengutronix.de>
 <72419ca8-b0cb-1e9d-3fcc-655defb662df@hartkopp.net>
 <20220128084603.jvrvapqf5dt57yiq@pengutronix.de>
 <07c69ccd-dbc0-5c74-c68e-8636ec9179ef@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jlbxuizszf7lp7c6"
Content-Disposition: inline
In-Reply-To: <07c69ccd-dbc0-5c74-c68e-8636ec9179ef@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jlbxuizszf7lp7c6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.01.2022 15:48:05, Oliver Hartkopp wrote:
> Hello Marc, hello William,
>=20
> On 28.01.22 09:46, Marc Kleine-Budde wrote:
> > On 28.01.2022 09:32:40, Oliver Hartkopp wrote:
> > >=20
> > >=20
> > > On 28.01.22 09:07, Marc Kleine-Budde wrote:
> > > > On 28.01.2022 08:56:19, Oliver Hartkopp wrote:
> > > > > I've seen the frame processing sometimes freezes for one second w=
hen
> > > > > stressing the isotp_rcv() from multiple sources. This finally fre=
ezes
> > > > > the entire softirq which is either not good and not needed as we =
only
> > > > > need to fix this race for stress tests - and not for real world u=
sage
> > > > > that does not create this case.
> > > >=20
> > > > Hmmm, this doesn't sound good. Can you test with LOCKDEP enabled?
>=20
>=20
> > > #
> > > # Lock Debugging (spinlocks, mutexes, etc...)
> > > #
> > > CONFIG_LOCK_DEBUGGING_SUPPORT=3Dy
> > > # CONFIG_PROVE_LOCKING is not set
> > CONFIG_PROVE_LOCKING=3Dy
>=20
> Now enabled even more locking (seen relevant kernel config at the end).
>=20
> It turns out that there is no visible difference when using spin_lock() or
> spin_trylock().
>=20
> I only got some of these kernel log entries
>=20
> Jan 28 11:13:14 silver kernel: [ 2396.323211] perf: interrupt took too lo=
ng
> (2549 > 2500), lowering kernel.perf_event_max_sample_rate to 78250
> Jan 28 11:25:49 silver kernel: [ 3151.172773] perf: interrupt took too lo=
ng
> (3188 > 3186), lowering kernel.perf_event_max_sample_rate to 62500
> Jan 28 11:45:24 silver kernel: [ 4325.583328] perf: interrupt took too lo=
ng
> (4009 > 3985), lowering kernel.perf_event_max_sample_rate to 49750
> Jan 28 12:15:46 silver kernel: [ 6148.238246] perf: interrupt took too lo=
ng
> (5021 > 5011), lowering kernel.perf_event_max_sample_rate to 39750
> Jan 28 13:01:45 silver kernel: [ 8907.303715] perf: interrupt took too lo=
ng
> (6285 > 6276), lowering kernel.perf_event_max_sample_rate to 31750
>=20
> But I get these sporadically anyway. No other LOCKDEP splat.
>=20
> At least the issue reported by William should be fixed now - but I'm still
> unclear whether spin_lock() or spin_trylock() is the best approach here in
> the NET_RX softirq?!?

With the !spin_trylock() -> return you are saying if something
concurrent happens, drop it. This doesn't sound correct.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jlbxuizszf7lp7c6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIA1CkACgkQrX5LkNig
010zTgf/X9PxwtwpT8fCXmMEHsIdtSANGvXX8JQ6l7gzK39LKaAwSqgkD0k3Smp5
8emrRja1pmf9sojVGyUpa/DcBCjR3CxblvyaWnsNbqGxRUB5uHXJsK455duJfGWg
VNdCCHlP2b2Slb0VjZ0g5CXA/DPQElxhHmN3AHvizfflW/RDMV79O2RNqRL9WZBx
x9wtHzjG6xH5XlO3ULplSD5TXH2GdU+7GYToR7qq7fD+XAarKTIAvdelCcITbfCY
Wu3XmvtlukCqEwnB1ijF0L5mKGdODON78ykkvqjg3tFm7Rw+yrGQrT22ZiTQe9SN
T7UFVAOKU7WcLXpa9jrDXJtxSHWjHw==
=TDl5
-----END PGP SIGNATURE-----

--jlbxuizszf7lp7c6--
