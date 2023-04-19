Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621916E72E2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjDSGKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbjDSGKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:10:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A4F45FD2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 23:10:45 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pp11Q-0006RU-9L; Wed, 19 Apr 2023 08:10:28 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DEC751B2A81;
        Wed, 19 Apr 2023 06:10:25 +0000 (UTC)
Date:   Wed, 19 Apr 2023 08:10:24 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Mendez, Judith" <jm@ti.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Andrew Davis <afd@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Message-ID: <20230419-stretch-tarantula-e0d21d067483-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
 <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
 <6eb588ef-ab12-186d-b0d3-35fc505a225a@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qu67lay6cc3reoxa"
Content-Disposition: inline
In-Reply-To: <6eb588ef-ab12-186d-b0d3-35fc505a225a@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qu67lay6cc3reoxa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.04.2023 11:15:35, Mendez, Judith wrote:
> Hello Marc,
>=20
> On 4/14/2023 12:49 PM, Marc Kleine-Budde wrote:
> > On 13.04.2023 17:30:46, Judith Mendez wrote:
> > > On AM62x there is one MCAN in MAIN domain and two in MCU domain.
> > > The MCANs in MCU domain were not enabled since there is no
> > > hardware interrupt routed to A53 GIC interrupt controller.
> > > Therefore A53 Linux cannot be interrupted by MCU MCANs.
> >=20
> > Is this a general hardware limitation, that effects all MCU domain
> > peripherals? Is there a mailbox mechanism between the MCU and the MAIN
> > domain, would it be possible to pass the IRQ with a small firmware on
> > the MCU? Anyways, that's future optimization.
>=20
> This is a hardware limitation that affects AM62x SoC and has been carried
> over to at least 1 other SoC. Using the MCU is an idea that we have juggl=
ed
> around for a while, we will definitely keep it in mind for future
> optimization. Thanks for your feedback.

Once you have a proper IRQ de-multiplexer, you can integrate it into the
system with a DT change only. No need for changes in the m_can driver.

> > > This solution instantiates a hrtimer with 1 ms polling interval
> > > for a MCAN when there is no hardware interrupt. This hrtimer
> > > generates a recurring software interrupt which allows to call the
> > > isr. The isr will check if there is pending transaction by reading
> > > a register and proceed normally if there is.
> > >=20
> > > On AM62x this series enables two MCU MCAN which will use the hrtimer
> > > implementation. MCANs with hardware interrupt routed to A53 Linux
> > > will continue to use the hardware interrupt as expected.
> > >=20
> > > Timer polling method was tested on both classic CAN and CAN-FD
> > > at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> > > switching.
> > >=20
> > > Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> > > 1 MBPS timer polling interval is the better timer polling interval
> > > since it has comparable latency to hardware interrupt with the worse
> > > case being 1ms + CAN frame propagation time and CPU load is not
> > > substantial. Latency can be improved further with less than 1 ms
> > > polling intervals, howerver it is at the cost of CPU usage since CPU
> > > load increases at 0.5 ms and lower polling periods than 1ms.

Have you seen my suggestion of the poll-interval?

Some Linux input drivers have the property poll-interval, would it make
sense to ass this here too?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--qu67lay6cc3reoxa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ/hc0ACgkQvlAcSiqK
BOiAWQgAjh1+EBUoAAUPx2ZOawWvxaMJ29t7nK75GAf+/TYlKVR0v4S1Mv1Z/qnM
rK65q4JaAcNgYSqxJso/6F9hwXxuLGZqhyitmfOPE5Wb3Gk9lP11h4GwfhSMBece
3Q/Bf0nvujl699psPIJq2vLZknERGkSGaMpsV1QsClPMxiPOAwlkk9GeYynvqkHo
9On1oPYV/SOtC23zV/h+v0etNxww+uXlgy3W7HNxDBzTfUpeiXf4R+X2TH99qjDZ
Uk8Zw8Htg/rhiYAGvOYZVTPeHKtTu6HQL3kh400kcqh2kJA0PI1DGQd353XQhXvf
DN8cR/kl4t5PaUITQ7WWYn777ZJp6g==
=+SWM
-----END PGP SIGNATURE-----

--qu67lay6cc3reoxa--
