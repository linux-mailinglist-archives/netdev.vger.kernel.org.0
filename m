Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026466E29B3
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjDNRvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbjDNRvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:51:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E200AF35
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:50:54 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pnNZ1-0007g5-WD; Fri, 14 Apr 2023 19:50:24 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2FC941AF3A6;
        Fri, 14 Apr 2023 17:49:16 +0000 (UTC)
Date:   Fri, 14 Apr 2023 19:49:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Andrew Davis <afd@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>
Subject: Re: [RFC PATCH 0/5] Enable multiple MCAN on AM62x
Message-ID: <20230414-tubular-service-3404c64c6c62-mkl@pengutronix.de>
References: <20230413223051.24455-1-jm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="faqeusbrotl4pfoh"
Content-Disposition: inline
In-Reply-To: <20230413223051.24455-1-jm@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--faqeusbrotl4pfoh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.04.2023 17:30:46, Judith Mendez wrote:
> On AM62x there is one MCAN in MAIN domain and two in MCU domain.
> The MCANs in MCU domain were not enabled since there is no
> hardware interrupt routed to A53 GIC interrupt controller.
> Therefore A53 Linux cannot be interrupted by MCU MCANs.

Is this a general hardware limitation, that effects all MCU domain
peripherals? Is there a mailbox mechanism between the MCU and the MAIN
domain, would it be possible to pass the IRQ with a small firmware on
the MCU? Anyways, that's future optimization.

> This solution instantiates a hrtimer with 1 ms polling interval
> for a MCAN when there is no hardware interrupt. This hrtimer
> generates a recurring software interrupt which allows to call the
> isr. The isr will check if there is pending transaction by reading
> a register and proceed normally if there is.
>=20
> On AM62x this series enables two MCU MCAN which will use the hrtimer
> implementation. MCANs with hardware interrupt routed to A53 Linux
> will continue to use the hardware interrupt as expected.
>=20
> Timer polling method was tested on both classic CAN and CAN-FD
> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> switching.
>=20
> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> 1 MBPS timer polling interval is the better timer polling interval
> since it has comparable latency to hardware interrupt with the worse
> case being 1ms + CAN frame propagation time and CPU load is not
> substantial. Latency can be improved further with less than 1 ms
> polling intervals, howerver it is at the cost of CPU usage since CPU
> load increases at 0.5 ms and lower polling periods than 1ms.

Some Linux input drivers have the property poll-interval, would it make
sense to ass this here too?

> Note that in terms of power, enabling MCU MCANs with timer-polling
> implementation might have negative impact since we will have to wake
> up every 1 ms whether there are CAN packets pending in the RX FIFO or
> not. This might prevent the CPU from entering into deeper idle states
> for extended periods of time.
>=20
> This patch series depends on 'Enable CAN PHY transceiver driver':
> https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fas=
tmail.com/T/

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--faqeusbrotl4pfoh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ5kgYACgkQvlAcSiqK
BOi8yAf+NQ1sGpY+JsIDIIU5iJz6hTu6JRL8rVVwXcJ0IuXgW9D877Gep4/5bAwF
GA1yEfBwJYq/6WzYe5flkwNeHAZ9aiiyrLPtKLY2NHlOjqpHY5j+0skKLeOU9nrD
Vn4eEBqPevkKPTrObp8WqFYEIGJ8upuRduBNDCkygc1mPjZxW8APaSvBLDhLKd4I
kRi8iMi6xv7kzSgi/lj+n3dDCTRCs6A4ireI3Yz1KpRx/2KujAef5HuDRma0xunv
FgqYz1GUPO6hCBBD4xpv80RyfL06Li4i6nkIOgjIIqPlbUtl0YMVDfceMtsOxaXu
l9ewAD+YepbkU542Luj6WaHP1oI9Ww==
=3Y9X
-----END PGP SIGNATURE-----

--faqeusbrotl4pfoh--
